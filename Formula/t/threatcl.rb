class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "de8d140cad1d5d00114712d2cb8325a1f3a8a8dac94f0e0d25c590bfb486639e"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f70a41ab79251a39ec7731f86430573042bd2f8b73c3fb432fae55898d497c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a9d400c1d7117456bb23952b3ed0c779fff5ce6a6b69617834569ab5d9464c"
    sha256 cellar: :any_skip_relocation, ventura:       "c647abd671a3319f4d643ade61912472b24b065e5fa6b34331117980680a5a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ceab5bc27c4d8b5165ea9d5523b20ae6027e02cd25b6f09f7f65819f9564b0f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
