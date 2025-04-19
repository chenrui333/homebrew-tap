class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "00d8d2858192b767783d6d234249a05f3f53268484bf24f4a6dcd212500637fe"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "634e5c120d94849bb899fb0d04623ff14995c2c075663341c3e2178faaaee737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ad05bb5ebe343c54d6d2ed76b2980e633ae3dacbc86ba09833b604294300900"
    sha256 cellar: :any_skip_relocation, ventura:       "220ab899a6747e1cdab68e51d8983d4e9a27f1bd46708c267534f36f693b69dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d7559d9b311f6d5c52f56b9924d14a79afcf429a9a4c0911401d9616f33215"
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
