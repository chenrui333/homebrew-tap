class RfcReader < Formula
  desc "RFC viewer with TUI"
  homepage "https://github.com/ozan2003/rfc_reader"
  url "https://github.com/ozan2003/rfc_reader/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "e58ccf29dc272bcc199c7a9d9418cc6c8aaea78cc7e8680581a5653d17e38350"
  license "MIT"
  head "https://github.com/ozan2003/rfc_reader.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rfc_reader --version")
    assert_match "Cache cleared", shell_output("#{bin}/rfc_reader --clear-cache")
  end
end
