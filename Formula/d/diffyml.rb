class Diffyml < Formula
  desc "Structural YAML diff tool with Kubernetes intelligence"
  homepage "https://github.com/szhekpisov/diffyml"
  url "https://github.com/szhekpisov/diffyml/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "86d1746ff1dad438da46ddbaae4681ab79cf65ad6d4c4a356eb1cd3c9fb1813b"
  license "MIT"
  head "https://github.com/szhekpisov/diffyml.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5defd0fe86181b46400846ac79bed64f28f472a8ec7b94a9adba7a2e834211c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5defd0fe86181b46400846ac79bed64f28f472a8ec7b94a9adba7a2e834211c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5defd0fe86181b46400846ac79bed64f28f472a8ec7b94a9adba7a2e834211c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e74baf8a5e62472e0f6626a0443c10e9c50e2fc16df75c702c54b89a3fc2e1"
    sha256 cellar: :any,                 x86_64_linux:  "695f7cb52b975257181d731d80cd1cb402df53e428cd718aed8cf53bea8b4015"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffyml --version")

    (testpath/"from.yml").write "name: old\n"
    (testpath/"to.yml").write "name: new\n"
    output = shell_output("#{bin}/diffyml --color never from.yml to.yml")
    assert_match "Found one difference", output
    assert_match "+ new", output
  end
end
