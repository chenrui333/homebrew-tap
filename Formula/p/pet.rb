class Pet < Formula
  desc "Simple command-line snippet manager"
  homepage "https://github.com/knqyf263/pet"
  url "https://github.com/knqyf263/pet/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "b829628445b8a7039f0211fd74decee41ee5eb1c28417a4c8d8fca99de59091f"
  license "MIT"
  head "https://github.com/knqyf263/pet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13a1fbee67bd40c496f65ad2f3e95f5bf04cdf7b0b9d943abec5b78817b98b6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13a1fbee67bd40c496f65ad2f3e95f5bf04cdf7b0b9d943abec5b78817b98b6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a1fbee67bd40c496f65ad2f3e95f5bf04cdf7b0b9d943abec5b78817b98b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df85db82914d3b487a4c1c7b1c05e1880b57667f949e21ac31f9c1729ed29f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b36a7d69c3290c458b8c7a7f824f1e4cc063ed8d2677d86de2dc0ed666e6140"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/knqyf263/pet/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pet version")
    assert_empty shell_output("#{bin}/pet list")
  end
end
