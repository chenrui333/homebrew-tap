class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "746347a429d25dd42bb23c1d59b8bb0e3a4ef0ff3f106d94950813acab19b1e7"
  head "https://github.com/ctoth/claudio.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "660d2f28031e6e8e76d4a277ce27753040e7e606f0a15e9f66633475dad24d7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f96e834511da49002bcd0bf773fc62839f04e2f85a723f6af84f8f69ebd696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ae722165e3aa471c7d152eb935cd04cc451debdbcd2044015be4334a15f71a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1863367003d7f268c25596dff6707bcd6a09da7f9e8e77b84c9059eaeb2dcf3f"
    sha256 cellar: :any,                 x86_64_linux:  "6b515712e74d786bd6dfe49cc4e429bb6633671fe50c96d005f8608ecdf94b91"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/claudio"

    generate_completions_from_executable bin/"claudio", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudio --version")
    output = shell_output("#{bin}/claudio analyze usage")
    assert_match "No sound usage data found for the specified criteria", output
  end
end
