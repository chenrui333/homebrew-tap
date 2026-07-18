class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "81056fa89c0b3fda9093d73485464426a82a72e27f5f0cb5c019663c788246ba"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "933513e1f2ba9d25f64175db0b24be7e8062ae4906ec55588aa9a66fb5dfa453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e440ddd0215a4f7efd4308c33ba927d45c7a4585e3351fb126ff2a85db19547f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "325bb5ae5a856fed94f88e261005c4d9b61301d68c99624e3a1c664fd07d1afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dedfecf882d860041e3c76dbc341160441a9ae201ccd383d44b70399e47780a3"
    sha256 cellar: :any,                 x86_64_linux:  "c67cb9b80b8b053321e5e821080803747f32a59748cc9ca2f1821fcd311e37f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kcl-lang.io/cli/pkg/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kcl"

    generate_completions_from_executable(bin/"kcl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kcl --version")

    (testpath/"test.k").write <<~EOS
      hello = "KCL"
    EOS
    assert_equal "hello: KCL", shell_output("#{bin}/kcl run #{testpath}/test.k").chomp
  end
end
