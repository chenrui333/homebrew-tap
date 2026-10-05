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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fa16d54ca84dace3a074d684edf792f07b3b0326b6dc9092bc1f3f51752042f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58e168b640f4615d23fd51c05cd2a8e79d276372d60e3e20b1795e129766eac8"
    sha256 cellar: :any,                 arm64_linux:   "7f672c2818191d365181ff197033f7b01a406dd7e83c2941cdfdae6e6026285d"
    sha256 cellar: :any,                 x86_64_linux:  "0d300f6f47edb7434a6120c7c03d5d81a3f842a4cb7802abc597726ac9587be9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "mdsf")

    [bash_completion/"mdsf", fish_completion/"mdsf.fish", zsh_completion/"_mdsf"].each do |completion_file|
      rm completion_file if completion_file.exist?
    end
    generate_completions_from_executable(bin/"mdsf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdsf --version")

    output = shell_output("#{bin}/mdsf --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
