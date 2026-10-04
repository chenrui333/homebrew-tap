class Grut < Formula
  desc "Terminal file explorer with Git and GitHub integration"
  homepage "https://github.com/jongio/grut"
  url "https://github.com/jongio/grut/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "791467840f9b3740ad2097614dcc17c527c61d2b1d367ddc2ebd609c23a7a681"
  license "MIT"
  head "https://github.com/jongio/grut.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/jongio/grut/internal/config.AppVersion=#{version}"
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
