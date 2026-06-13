class Dloom < Formula
  desc "Dotfile and configuration weaver tool"
  homepage "https://github.com/dloomorg/dloom"
  url "https://github.com/dloomorg/dloom/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "5d01c61d102dc91b2cbe472626d1cc495f605a66684f8587d6113dd66a8bd1ee"
  license "MIT"
  head "https://github.com/dloomorg/dloom.git", branch: "main"

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
