class Adbtop < Formula
  desc "Monitor Android app performance over ADB from the terminal"
  homepage "https://github.com/aabolfazl/adbtop"
  url "https://github.com/aabolfazl/adbtop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee7a9108bc1aa15bfefffde375f0d02998169d1231fc6d31fc4935095c59d74d"
  license "MIT"
  head "https://github.com/aabolfazl/adbtop.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "71f9420ed198d3277cc36ea2f98d9f8ed08559920d9c0574f98734277ba51fe4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cbd00432d0c4731129a962b4d9d40709c693e7bfe9d1e4d25793a66514c15a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ee7f25922b59c61b30ad315bbed4d41c8e4b727e3ef59922bff3caecece91b"
    sha256 cellar: :any,                 arm64_linux:   "6aff4ee2285fc780a13b9502afd3d9d924830d52cfaede80fd99fd69e734ce77"
    sha256 cellar: :any,                 x86_64_linux:  "cc6208f8ad32b8f9b1ce582194ed369212f25c019ee4f616ac7073ee69ac6a48"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Install Android SDK Platform-Tools and put adb on your PATH.
      For optional network capture, use `adbtop agent install --apk FILE`
      with the matching capture agent APK. The APK is not bundled.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbtop --version")
    assert_match "Tokyo Night", shell_output("#{bin}/adbtop themes")
  end
end
