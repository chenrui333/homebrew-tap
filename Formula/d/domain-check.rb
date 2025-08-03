class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://github.com/saidutt46/domain-check/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "37d3c700d288d8beac3e6685d23a6034de5fb10538691dc53f6c679a26e76fb4"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a53f9f03e6cf1e212fbdbfdce9a7d264952eaf3904702d81695be5deecc4935a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ab218fd23460bd9d0bc5ea07a4bad94bf34372301187cbae8410a5758158b78"
    sha256 cellar: :any_skip_relocation, ventura:       "455b05d4441724eaf98ab39ddeb51c816f6bf8f0cb8dec4b6b71e9806d5c995b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30107dd9aaccb48023532708d594809bd8506a6f1288395f35ae2f837a93218a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "domain-check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/domain-check --version")

    output = shell_output("#{bin}/domain-check example.com")
    assert_match "example.com TAKEN", output

    output = shell_output("#{bin}/domain-check invalid_domain 2>&1", 1)
    assert_match "Error: No valid domains found to check", output
  end
end
