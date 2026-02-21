class Auox < Formula
  desc "Terminal banking application for SpareBank 1 customers"
  homepage "https://github.com/sverrejb/auox"
  url "https://github.com/sverrejb/auox/archive/a61e3b907ad6883806b06b1e23ee7247e540bee7.tar.gz"
  version "0.0.1"
  sha256 "5fa0c17426ab4554f6d3c4d04aed25e1bc007312790ff107853d84260d6a8028"
  license "MIT"
  head "https://github.com/sverrejb/auox.git", branch: "main"

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
