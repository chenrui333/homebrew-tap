class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "411c73b991fbb98849595ed6e5b42ec65b577f8b23b29bb62926bd4a8d65a17d"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35bd70b1d255ce1bb14a71116b49b7dc88d7d6986c8aac23b59fd927de1c626b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35bd70b1d255ce1bb14a71116b49b7dc88d7d6986c8aac23b59fd927de1c626b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35bd70b1d255ce1bb14a71116b49b7dc88d7d6986c8aac23b59fd927de1c626b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "052778f3f3960f7659c7f4b53a109a546846e7918774a27e0d7fb65b5e319078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be116493889a24f21ff32ddfebb45edcec31e1eeaac59885c52d56fbf9e88e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"orla"), "./cmd/orla"
    generate_completions_from_executable(bin/"orla", "completion", shell_parameter_format: :cobra)
  end

  test do
    ENV["HOME"] = testpath
    (testpath/".orla/tools").mkpath
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    assert_match "[]", shell_output("#{bin}/orla tool list --json")
  end
end
