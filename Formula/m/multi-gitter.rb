class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "a5fb523d5bc53f1526439d79d45770c32596f7a0a5de4dbbe53ea2ab47494e7e"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ea9bebaed17cbe20aacb98e3f12bd850138dc81d839b5456d0a732af81523f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c823a9f1a99e42693b1866d82f53f27455ad92eac02b83a54bf94b1244cf9a4"
    sha256 cellar: :any_skip_relocation, ventura:       "c1102eb8bd9cbd9c471c888236a18a44e1eb4f03fe320ab96f89e26f9ae2fce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f13b7518d115dc9766712658a80f2de7145ec368cd8c4844a48e73ad47a2dec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
