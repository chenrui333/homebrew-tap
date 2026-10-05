class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.10.3.tar.gz"
  sha256 "21aee0453d020ac8e9840b064b3c048247b70c8f9b12243c931bb408b80d33e4"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff6331572aa0c05e746196aad91f6d03683710e430557177193d94421de1a378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bc752b4adeb77b48556876d69abfab921be77944d4ea534e4e40f4c6fb58997"
    sha256 cellar: :any,                 arm64_linux:   "cb6bd0b08169b7ee89d74f8a6b93b083941445c1c3cc1836813bed6d687abf16"
    sha256 cellar: :any,                 x86_64_linux:  "304fe01846e460231d7e72cdae7355639d0234741b100429a9860b2ce2900b7b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
