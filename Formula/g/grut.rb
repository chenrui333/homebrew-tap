class Grut < Formula
  desc "Terminal file explorer with Git and GitHub integration"
  homepage "https://github.com/jongio/grut"
  url "https://github.com/jongio/grut/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "024a10cfcdbb02837fb0a0bf664729511dc325de29711b049f50852eb6d647d1"
  license "MIT"
  head "https://github.com/jongio/grut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc8f296f6209507bd49ad013f3c5a1fd3f6294b8911ece83a1eaffacda60b693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8f296f6209507bd49ad013f3c5a1fd3f6294b8911ece83a1eaffacda60b693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d22e3ee86c7ec62cf530941bd0bab6294829039daa2132819a6b80481c390b"
    sha256 cellar: :any,                 x86_64_linux:  "709c659d4a3edd0944e0340ba7eb0d5faca1413e8cdfa343437403a748007090"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/jongio/grut/internal/config.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"grut", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grut --version")
    assert_equal [], JSON.parse(shell_output("#{bin}/grut keys --section homebrew-missing --json"))
    sections = JSON.parse(shell_output("#{bin}/grut keys --section filetree --json"))
    assert_equal "File Tree", sections.first.fetch("title")
    refute_empty sections.first.fetch("bindings")
  end
end
