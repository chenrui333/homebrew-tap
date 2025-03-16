class KubesealConvert < Formula
  desc "Tool to import secrets from secret managers (Vault, SecretsMgr) to SealedSecret"
  homepage "https://github.com/EladLeev/kubeseal-convert"
  url "https://github.com/EladLeev/kubeseal-convert/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "1d6e0b012d9d3d6dd54ac535aa092442d50f41faa6047862a3d057eb528593ce"
  license "Apache-2.0"
  head "https://github.com/EladLeev/kubeseal-convert.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"kubeseal-convert", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubeseal-convert --version")

    output = shell_output("#{bin}/kubeseal-convert sm \"fake\" --namespace test-ns --name test-secret 2>&1", 1)
    assert_match "failed to get secret: operation error Secrets Manager", output
  end
end
