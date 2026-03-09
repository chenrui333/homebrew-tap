class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "170db766a08d485c82e9ca446c06abe66329642540c6e7f289093d5cba000a65"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b5518dbec07d23870f94f0410d7c4f430f35e0d88103b5561df893adcab9c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d839e11416d89ce29cfe74f2bc98301e77079d62a6df7fb2ef5948a48053683c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbe88a94def0b2da78b39cb35b83b333947427b8890935b038d7724ff9ca2eb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8944be46ddb57df61386f728a6906641626fc89b5b82557f748e5cb1390903bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef52e2373a980588e3f1615cd22c42eb0fdc88d7493e0cef42686d69ebb5530"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
