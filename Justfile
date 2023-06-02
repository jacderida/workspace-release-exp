#!/usr/bin/env just --justfile

release_repo := "jacderida/workspace-release-exp"

build-release-artifacts arch:
  #!/usr/bin/env bash
  set -e

  arch="{{arch}}"
  supported_archs=(
    "x86_64-pc-windows-msvc"
    "x86_64-apple-darwin"
    "x86_64-unknown-linux-musl"
    "arm-unknown-linux-musleabi"
    "armv7-unknown-linux-musleabihf"
    "aarch64-unknown-linux-musl"
  )

  arch_supported=false
  for supported_arch in "${supported_archs[@]}"; do
    if [[ "$arch" == "$supported_arch" ]]; then
      arch_supported=true
      break
    fi
  done

  if [[ "$arch_supported" == "false" ]]; then
    echo "$arch is not supported."
    exit 1
  fi

  if [[ "$arch" == "x86_64-unknown-linux-musl" ]]; then
    if [[ "$(grep -E '^NAME="Ubuntu"' /etc/os-release)" ]]; then
      # This is intended for use on a fresh Github Actions agent
      sudo apt update -y
      sudo apt install -y musl-tools
    fi
    rustup target add x86_64-unknown-linux-musl
  fi

  rm -rf artifacts
  mkdir artifacts
  cargo clean
  if [[ $arch == arm* || $arch == armv7* || $arch == aarch64* ]]; then
    cargo install cross
    cross build --release --target $arch --bin adder
    cross build --release --target $arch --bin adder2
  else
    cargo build --release --target $arch --bin adder
    cargo build --release --target $arch --bin adder2
  fi

  find target/$arch/release -maxdepth 1 -type f -exec cp '{}' artifacts \;
  rm -f artifacts/.cargo-lock

package-release-assets bin version="":
  #!/usr/bin/env bash
  set -e

  architectures=(
    "x86_64-pc-windows-msvc"
    "x86_64-apple-darwin"
    "x86_64-unknown-linux-musl"
    "arm-unknown-linux-musleabi"
    "armv7-unknown-linux-musleabihf"
    "aarch64-unknown-linux-musl"
  )

  bin="{{bin}}"
  case "$bin" in
    adder)
      crate="jacderida-exp2-adder"
      ;;
    adder2)
      crate="jacderida-exp2-adder2"
      ;;
    *)
      echo "The only supported binaries are adder or adder2"
      exit 1
      ;;
  esac

  if [[ -z "{{version}}" ]]; then
    version=$(grep "^version" < $crate/Cargo.toml | head -n 1 | awk '{ print $3 }' | sed 's/\"//g')
  else
    version="{{version}}"
  fi

  rm -rf deploy/$bin
  find artifacts/ -name "$bin" -exec chmod +x '{}' \;
  for arch in "${architectures[@]}" ; do
    echo "Packaging for $arch..."
    if [[ $arch == *"windows"* ]]; then bin_name="${bin}.exe"; else bin_name=$bin; fi
    zip -j $bin-$version-$arch.zip artifacts/$arch/release/$bin_name
    tar -C artifacts/$arch/release -zcvf $bin-$version-$arch.tar.gz $bin_name
  done

  mkdir -p deploy/$bin
  mv *.tar.gz deploy/$bin
  mv *.zip deploy/$bin

upload-release-assets:
  #!/usr/bin/env bash
  set -e

  binary_crates=(
    "jacderida-exp2-adder"
    "jacderida-exp2-adder2"
  )

  commit_msg=$(git log -1 --pretty=%B)
  # Remove 'chore(release): ' prefix
  commit_msg=${commit_msg#*: }

  IFS='/' read -ra crates_with_versions <<< "$commit_msg"
  declare -a crate_names
  for crate_with_version in "${crates_with_versions[@]}"; do
    crate=$(echo "$crate_with_version" | awk -F'-v' '{print $1}')
    crates+=("$crate")
  done

  for crate in "${crates[@]}"; do
    for binary_crate in "${binary_crates[@]}"; do
        if [[ "$crate" == "$binary_crate" ]]; then
            case "$crate" in
              jacderida-exp2-adder)
                bin_name="adder"
                ;;
              jacderida-exp2-adder2)
                bin_name="adder2"
                ;;
              *)
                echo "The only supported binaries are adder or adder2"
                exit 1
                ;;
            esac
            # The crate_with_version variable will correspond to the tag name of the release.
            # However, only binary crates have releases, so we need to skip any tags that don't
            # correspond to a binary.
            for crate_with_version in "${crates_with_versions[@]}"; do
              if [[ $crate_with_version == $crate-v* ]]; then
                (
                  echo "Uploading $bin_name assets to $crate_with_version release..."
                  cd deploy/$bin_name
                  ls | xargs gh release upload $crate_with_version --repo {{release_repo}}
                )
              fi
            done
        fi
    done
  done
