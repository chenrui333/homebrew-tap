# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "dde37767de63cca26b3ac8f7a8aafe06545cf4248d4a011fa1f26b68d4db34fb"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc31a71eefab0d2198198dcad1b8c8f83c4d1c5c12689fa5214ebed7623ae26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fcfabb0c8acc3e0a8cf5642ef6d94a175d4803ff69cb7b9d0a77810937167e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9142fe75548600b8de976af542b058b8d82c83e3238c1465637f8a691d0ffff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e88d235f10b71d572c193caa1f703c85cca9f8aac323d25823d12fa8ae2a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4771f3d7d7f3214401db082aa04217d97a78204e639c56b5ef707354b9ec1bf8"
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
    assert_match "mdsf__format)", output
  end
end
