class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.89.tar.gz"
  sha256 "c7f3969677843348a4f99e0a04f39fe77d5525c2bf7dd4c16da9071fb91ad255"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d65f2f69c842a0a42e9c48aea532bd942d5aa76cf346bea300a3998e4dccbe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d65f2f69c842a0a42e9c48aea532bd942d5aa76cf346bea300a3998e4dccbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d65f2f69c842a0a42e9c48aea532bd942d5aa76cf346bea300a3998e4dccbe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae6f1697c9ce23538b2766aa1e957c5b14571f436c54602d10610e133e202176"
    sha256 cellar: :any,                 x86_64_linux:  "d6adbd2f42433bb3c80f555188a4506564f972611be71292c847df4269505d1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
