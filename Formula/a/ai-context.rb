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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30309c845c86af12d4f681dbeff4dee353feff9d5b55c0dc495611d4a6c13a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30309c845c86af12d4f681dbeff4dee353feff9d5b55c0dc495611d4a6c13a64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30309c845c86af12d4f681dbeff4dee353feff9d5b55c0dc495611d4a6c13a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "babc4e20239b70dda4c374610bd11067b1f532c8b3101a1cc3ddeaa66b2e6efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c44e4da6455c8f59594decb3914ea9dd36f197369ba1e51ed8f26cbcd20191a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tanq16/ai-context/cmd.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["NO_COLOR"] = "1"

    (testpath/"sample/README.md").write "# Homebrew test\n"

    output = shell_output("#{bin}/ai-context sample")
    assert_match "Completed all operations successfully", output
    context_file = testpath/"context/dir-sample.md"
    assert_path_exists context_file
    assert_match "Homebrew test", context_file.read

    assert_match version.to_s, shell_output("#{bin}/ai-context --version")
  end
end
