class Ftdv < Formula
  desc "Terminal-based file tree diff viewer with flexible diff tool integration"
  homepage "https://github.com/wtnqk/ftdv"
  url "https://github.com/wtnqk/ftdv/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8a0dff5da5c5992f1ee16448974c4fea91bf4df96565305bfe19c4833bdf54e8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wtnqk/ftdv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb4e8f41fb75ae2bf345b376c85b965db105df35b47dca5e4ef5cdaa0a354402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dd183a42f38a9c8459d9c81f68ba388d09808d37680538f57e1bd9d21442256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "397781a93b49824d14475b96535a600f73a608320eda7576d1b7ad6bada4601f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b3859f580e65b2159b8a51e0a35a87b03d05a4cf28782369fb2e80c303b88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d89c89cfbaea33634dadfcfe3568617b02a04dd7a2fa9db54a591491f5e74fd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"ftdv", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ftdv --version")

    bash_completion = shell_output("#{bin}/ftdv completions bash")
    assert_match "_ftdv", bash_completion
    assert_match "status", bash_completion
    assert_match "completions", bash_completion
  end
end
