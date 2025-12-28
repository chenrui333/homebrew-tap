class KubesealConvert < Formula
  desc "Tool to import secrets from secret managers (Vault, SecretsMgr) to SealedSecret"
  homepage "https://github.com/EladLeev/kubeseal-convert"
  url "https://github.com/EladLeev/kubeseal-convert/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "1d6e0b012d9d3d6dd54ac535aa092442d50f41faa6047862a3d057eb528593ce"
  license "Apache-2.0"
  head "https://github.com/EladLeev/kubeseal-convert.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac3f67f8fb602b70386d138ab719707ec17f9c3213188899cc8fb3f2ee242023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af47965efa0bd1d0eec709cfa6f304e5bc20f2b8620b1f8ae3530231a02d817d"
    sha256 cellar: :any_skip_relocation, ventura:       "98d741de2820f1cf7cd143b8174173a0dc54ddf18a52f0634a8a164e491b501f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44e6be718fddb24b39d06319e9add190d6cc693fa1982c1083fc535135a0b483"
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
