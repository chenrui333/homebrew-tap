# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "c52026f5ea823e5462c815b045c1c705a04288c40052dc4390af2dcb0bacbc11"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc2fb00b95c2cb030e30b6c77a77447b88fba06520f663b314d5d3ae1bf6edc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2fb00b95c2cb030e30b6c77a77447b88fba06520f663b314d5d3ae1bf6edc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc2fb00b95c2cb030e30b6c77a77447b88fba06520f663b314d5d3ae1bf6edc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc5f7df6c78fcaa3c88ffc66145bb3ae349301ca29ef5f6cacd9ae061f11e92e"
    sha256 cellar: :any,                 x86_64_linux:  "2d5d153d9e22e7365203a74b073471a532de4bf36d2c5009ada2def5daf751e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tanq16/ai-context/cmd.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["NO_COLOR"] = "1"

    (testpath/"sample/README.md").write "# Homebrew test\n"

    output = shell_output("#{bin}/ai-context ./sample")
    assert_match "Completed all operations successfully", output
    context_file = testpath/"context/dir-sample.md"
    assert_path_exists context_file
    assert_match "Homebrew test", context_file.read

    assert_match version.to_s, shell_output("#{bin}/ai-context --version")
  end
end
