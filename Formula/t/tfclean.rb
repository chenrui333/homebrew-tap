class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "f2a958138b5449a60fad58becb8d66e556646405771c4a2c58c7d6f2db79c3a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa13a214941406a2d4a23eeedf020ad277af0e5958cd0bca5621db9eb667ea27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa13a214941406a2d4a23eeedf020ad277af0e5958cd0bca5621db9eb667ea27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa13a214941406a2d4a23eeedf020ad277af0e5958cd0bca5621db9eb667ea27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0d10fd9b961ded6cb0d35d2b0ec43332012d653e7b94af731c84de41a87aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01627b270c37607430650aae75ba817086d9b71ebd82851f1524499a52ae6816"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/takaishi/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean.Revision=#{tap.user}
      -X github.com/takaishi/tfclean/cmd/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean/cmd/tfclean.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfclean"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfclean --version")

    # https://github.com/opentofu/opentofu/blob/main/internal/command/e2etest/testdata/tf-provider/test.tfstate
    (testpath/"test.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "0.13.0",
        "serial": 1,
        "lineage": "8fab7b5a-511c-d586-988e-250f99c8feb4",
        "outputs": {
          "out": {
            "value": "test",
            "type": "string"
          }
        },
        "resources": []
      }
    EOS

    system bin/"tfclean", testpath, "--tfstate=#{testpath}/test.tfstate"
  end
end
