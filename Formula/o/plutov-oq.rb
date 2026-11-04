class PlutovOq < Formula
  desc "Terminal OpenAPI Spec viewer"
  homepage "https://github.com/plutov/oq"
  url "https://github.com/plutov/oq/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "0da761bcaea118d351b0ca106e327e2131d404f571b684fa8f4240ebaed2e8bb"
  license "MIT"
  head "https://github.com/plutov/oq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ee01639bd409dfdc2307ad85630978851e5181d80a056f40341930277ad6b9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee01639bd409dfdc2307ad85630978851e5181d80a056f40341930277ad6b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e313388dbfb3f5a46ef93806bfa671f350a8d89f01e5c2742e4e0411ee6a5bfc"
    sha256 cellar: :any,                 x86_64_linux:  "00ce554ae5aba81293d29dd495bc006be1c06681652d433cf442136d0c0ea252"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"oq")
  end

  test do
    (testpath/"openapi.yaml").write "not: [valid\n"
    output = shell_output("#{bin}/oq #{testpath}/openapi.yaml 2>&1", 1)
    assert_match "unable to parse specification", output
  end
end
