class Auox < Formula
  desc "Terminal banking application for SpareBank 1 customers"
  homepage "https://github.com/sverrejb/auox"
  url "https://github.com/sverrejb/auox/archive/a61e3b907ad6883806b06b1e23ee7247e540bee7.tar.gz"
  version "0.0.1"
  sha256 "5fa0c17426ab4554f6d3c4d04aed25e1bc007312790ff107853d84260d6a8028"
  license "MIT"
  head "https://github.com/sverrejb/auox.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a2af2e567e11f896c3c1ba7ed57954c01e40106f8a0f5271a32d60015bddefc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5699bbd5efed65615743f352c2047fbb783428f2c6acb327e397cde872d112ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45378be52ca031bb6dd4e21f7562e89d7a18009237419b9dae15e9b1b2a41271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e5a2d85f92ce2d8a0b398e85383c443e96aab77ebaedb6212247c3001be632f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7742a74c053e5554fb247dc2d5b02ef740b57e79325ffd24733ad7099d0590b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    output = shell_output("#{bin}/auox 2>&1", 101)
    config_file = if OS.mac?
      testpath/"Library/Application Support/auox/config.toml"
    else
      testpath/".config/auox/config.toml"
    end

    assert_path_exists config_file
    assert_match "client_id", config_file.read
    assert_match "Config file created at:", output
  end
end
