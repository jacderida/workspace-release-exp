#!/usr/bin/env just --justfile

release_repo := "jacderida/workspace-release-exp"

build-release-artifacts arch bin:
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
    cross build --release --target $arch --bin {{bin}}
  else
    cargo build --release --target $arch --bin {{bin}}
  fi

  find target/$arch/release -maxdepth 1 -type f -exec cp '{}' artifacts \;
  rm -f artifacts/.cargo-lock

package-release-assets crate version="":
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

  case "{{crate}}" in
    safe)
      crate="jacderida-exp-adder"
      bin_name="adder"
      ;;
    safenode)
      crate="jacderida-exp-adder2"
      bin_name="adder2"
      ;;
    *)
      echo "The only supported crates are adder or adder2"
      exit 1
      ;;
  esac

  if [[ -z "{{version}}" ]]; then
    version=$(grep "^version" < $crate/Cargo.toml | head -n 1 | awk '{ print $3 }' | sed 's/\"//g')
  else
    version="{{version}}"
  fi

  rm -rf deploy/$bin_name
  find artifacts/ -name $bin_name -exec chmod +x '{}' \;
  for arch in "${architectures[@]}" ; do
    if [[ $arch == *"windows"* ]]; then bin_name="${bin_name}.exe"; fi
    zip -j $bin_name-$version-$arch.zip artifacts/$arch/release/$bin_name
    tar -C artifacts/$arch/release -zcvf $bin_name-$version-$arch.tar.gz $bin_name
  done

  mkdir -p deploy/$crate
  mv *.tar.gz deploy/$crate
  mv *.zip deploy/$crate
