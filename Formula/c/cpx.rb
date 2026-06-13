class Cpx < Formula
  desc "Batteries-included Cargo-like CLI for C++"
  homepage "https://cpx-dev.vercel.app/"
  url "https://github.com/ozacod/cpx/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "40eb5aaf1dcf7dbaa2f6d950c61743fcbe172887c3a0886477f1b29e75459749"
  license "MIT"
  head "https://github.com/ozacod/cpx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac12dd92699a6d5e574c3e75132b42646609140c9acaa7c121b26470e5864a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac12dd92699a6d5e574c3e75132b42646609140c9acaa7c121b26470e5864a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cac12dd92699a6d5e574c3e75132b42646609140c9acaa7c121b26470e5864a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65b2e0bc05352f453ca838ea79cf129ebb2179058155a6c63ccd5beaa65627cd"
    sha256 cellar: :any,                 x86_64_linux:  "afc294aa3ee249d16c5055610c81e11b002b361480b5823308b8a0e8ea1efadc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpx"

    generate_completions_from_executable(bin/"cpx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpx version")
    output = shell_output("#{bin}/cpx not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
