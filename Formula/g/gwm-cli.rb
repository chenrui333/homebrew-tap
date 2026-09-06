class GwmCli < Formula
  desc "Git worktree manager with a terminal interface"
  homepage "https://github.com/kbrdn1/gwm-cli"
  url "https://github.com/kbrdn1/gwm-cli/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e391e8fc652720773cc71ba73eeee5b3d53369584f160658616992c3216910a4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/kbrdn1/gwm-cli.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"gwm", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gwm --version")
    output = shell_output("#{bin}/gwm list 2>&1", 1)
    assert_match "not inside a git repository", output
  end
end
