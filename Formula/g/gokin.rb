class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "12590b9848fc9653aab478166838ea075a4f19e43b8d78d579cb9769ec2cc105"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d10892243dd6d8bda2e8a415e36875760a63497ba5ab87f7d91faa5f558be293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d10892243dd6d8bda2e8a415e36875760a63497ba5ab87f7d91faa5f558be293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d10892243dd6d8bda2e8a415e36875760a63497ba5ab87f7d91faa5f558be293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "167b33095fb2d13b6b0a9a3d8b905d697077fa6ad0fce5c1863f7f64c0055e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bca55418661189f9028bc6ba526ec5c868f9d35b308208599f1eb6206967fe4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
