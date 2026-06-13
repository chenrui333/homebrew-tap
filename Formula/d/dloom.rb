class Dloom < Formula
  desc "Dotfile and configuration weaver tool"
  homepage "https://github.com/dloomorg/dloom"
  url "https://github.com/dloomorg/dloom/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "5d01c61d102dc91b2cbe472626d1cc495f605a66684f8587d6113dd66a8bd1ee"
  license "MIT"
  head "https://github.com/dloomorg/dloom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53bf96c395499f12751c641f2cc672ee6373840857bb7acd92bb7b945083792e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53bf96c395499f12751c641f2cc672ee6373840857bb7acd92bb7b945083792e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53bf96c395499f12751c641f2cc672ee6373840857bb7acd92bb7b945083792e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df8ca552b61ef1ac49cd756d489bc6944eedc881924a18a17d40a8825399b300"
    sha256 cellar: :any,                 x86_64_linux:  "3ca8296e32f85560249c5a7ef340dcfe751ee98211d8514d13fed7cf2f5418e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dloomorg/dloom/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dloom", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dloom version")

    (testpath/"dloom").mkpath
    (testpath/"dloom/config.yaml").write <<~YAML
      version: 0.0.1
    YAML
    assert_match "Would run script: bootstrap", shell_output("#{bin}/dloom --dry-run setup bootstrap")
  end
end
