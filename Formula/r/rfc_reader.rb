class RfcReader < Formula
  desc "RFC viewer with TUI"
  homepage "https://github.com/ozan2003/rfc_reader"
  url "https://github.com/ozan2003/rfc_reader/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "e58ccf29dc272bcc199c7a9d9418cc6c8aaea78cc7e8680581a5653d17e38350"
  license "MIT"
  head "https://github.com/ozan2003/rfc_reader.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9d861f1b238816578cf18b601497f644b319f941886cc5b986b45a9bbbfd89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7a4563f337cc1e37425548f3196954d99c6d637c7df7b2838457dbeecaecc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dce7ff303b7fe44205c380b8af6b7265a321e05fbc5c937db469b47ae961804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4c58669d2e98377f370ee2932f3310eaf81f94f33ec3d7d535073681f9efd94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418d48ea5f8ac1756a38671c85f96ce54e691f5a675d8515cffd6d70b782d363"
  end

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
