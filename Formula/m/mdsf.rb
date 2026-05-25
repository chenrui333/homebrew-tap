# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "c79a131f6e15804c99cff4c9ea0fe917e6b935e3524341255cc323973d2be7fc"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8745e524516d482d7ca650a1e6fb2274642b70f6ac58e17c28387f4c153cc75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969a3855e45b4db12e6a094fd3d0b40b8f79d5fe4b1a1af9ca1af6c2750cecba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da52ddff818e6a604917fd3868c64f2edce649ffbf31c40fb4e52874387602a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f44dae06c1053f13f57d8a39f18de753197f4dec380726e5bea84f741908f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b622aa9dd0ea72c742227f9347ea3b10f921642a7f2906f2c912e03276a972c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mdsf")

    [bash_completion/"mdsf", fish_completion/"mdsf.fish", zsh_completion/"_mdsf"].each do |completion_file|
      rm completion_file if completion_file.exist?
    end
    generate_completions_from_executable(bin/"mdsf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdsf --version")

    output = shell_output("#{bin}/mdsf completions bash")
    assert_match "_mdsf()", output
    assert_match "mdsf__subcmd__format)", output
  end
end
