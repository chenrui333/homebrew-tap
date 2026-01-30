class Aic < Formula
  desc "Fetch the latest changelogs for popular AI coding assistants"
  homepage "https://github.com/arimxyer/aic"
  url "https://github.com/arimxyer/aic/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "676fca3cff1234d54978ad921d08895d993d288079a0ca315f64f4094ace105f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b182af84ab761ade0ebd96c1584bf73fa55d534a08830d9e08605d290d731f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b182af84ab761ade0ebd96c1584bf73fa55d534a08830d9e08605d290d731f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b182af84ab761ade0ebd96c1584bf73fa55d534a08830d9e08605d290d731f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c90700d83cafec06d27b0b95b0f42d44cb61206bbec7f4014b994b9e077954b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140f677f7b8c150138951cd746a13168e4e5494fc1af5e62209bc14e5fb1ede7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aic --version")
    assert_match "Claude Code", shell_output("#{bin}/aic claude")
  end
end
