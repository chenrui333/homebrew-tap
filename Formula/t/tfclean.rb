class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "420c2e6c30ccbc79e27035f6eaccefbec1ef260232720a9bf07d86e73ad813ca"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24714de5bd2f762267a445666bedabd0d5d1cd2e52e9ecda993b98ff8f6c46ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a54250fed0c7a60b8da0e5ca007b6c464bd9c97c14bde75d790edef5452d0def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efca085187a5c0011239818ff9efdb177ba0fd67ba68bcb81e2bd16deca8ad0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
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
