class KubesealConvert < Formula
  desc "Tool to import secrets from secret managers (Vault, SecretsMgr) to SealedSecret"
  homepage "https://github.com/EladLeev/kubeseal-convert"
  url "https://github.com/EladLeev/kubeseal-convert/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "1d6e0b012d9d3d6dd54ac535aa092442d50f41faa6047862a3d057eb528593ce"
  license "Apache-2.0"
  head "https://github.com/EladLeev/kubeseal-convert.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cc55a8c31d9dbbb0ce8fd2a1786fc02e6637cf6dd4f9d553f623813a45e471e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc55a8c31d9dbbb0ce8fd2a1786fc02e6637cf6dd4f9d553f623813a45e471e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc55a8c31d9dbbb0ce8fd2a1786fc02e6637cf6dd4f9d553f623813a45e471e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "128faa69f618e1f1f626c636d07882a7bcf09b4bbfb01afb9bc36a80b3f33fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24984ded1e69d0dcf3c182f20bfbd3ec30d9201be6e78fca62db4bde61cc6f21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"kubeseal-convert", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubeseal-convert --version")

    output = shell_output("#{bin}/kubeseal-convert sm \"fake\" --namespace test-ns --name test-secret 2>&1", 1)
    assert_match "failed to get secret: operation error Secrets Manager", output
  end
end
