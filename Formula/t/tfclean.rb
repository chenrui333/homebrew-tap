class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "f2a958138b5449a60fad58becb8d66e556646405771c4a2c58c7d6f2db79c3a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd10b900ee171e1b7e9bcb7c339c149f95921390948a355854a7f3061ca5588a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd10b900ee171e1b7e9bcb7c339c149f95921390948a355854a7f3061ca5588a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd10b900ee171e1b7e9bcb7c339c149f95921390948a355854a7f3061ca5588a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ae64697253f8da7cf72f12651a8b9e8d3def99ae037b0f374281153e88d0fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3741dc5e5ea298da715041ed150fc1c5f8204a01f953e6512bda68932f8c051"
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
