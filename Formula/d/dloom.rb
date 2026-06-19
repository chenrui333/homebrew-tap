class Dloom < Formula
  desc "Dotfile and configuration weaver tool"
  homepage "https://github.com/dloomorg/dloom"
  url "https://github.com/dloomorg/dloom/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "5d01c61d102dc91b2cbe472626d1cc495f605a66684f8587d6113dd66a8bd1ee"
  license "MIT"
  head "https://github.com/dloomorg/dloom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1386266e99b1ee7ba8a406a0788e49739950513ecbcee34a763e37826397662e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1386266e99b1ee7ba8a406a0788e49739950513ecbcee34a763e37826397662e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1386266e99b1ee7ba8a406a0788e49739950513ecbcee34a763e37826397662e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46cc6fbf528acc371e6a2db51815bb40e126284fa83f8f5a28de62f9680a9380"
    sha256 cellar: :any,                 x86_64_linux:  "53497ae9da628a68a23590ac711fdd274abd3154cb56a9e78601a0b6efdcb28a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dloomorg/dloom/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dloom", shell_parameter_format: :cobra)
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
