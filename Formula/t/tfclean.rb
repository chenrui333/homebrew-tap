class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "420c2e6c30ccbc79e27035f6eaccefbec1ef260232720a9bf07d86e73ad813ca"
  # license bug report, https://github.com/takaishi/tfclean/issues/70

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d099ed0dfe55a322a38e79fd6654d995e2917a55e28cac4dffb95c91cbf6dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c163ad14cc44bf2906d2f231197e7fd2422c4b7d3dc365546b6f73526565fa6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8637d71f77ad66e1457196b16f07f2a157406a76336bbb7e4ad000cbf95bb09"
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
