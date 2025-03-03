class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "913a7bce4f2e4596e64d91d0e4259e2dac28adedf6f0737b6d4e01afc7a849a7"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ccb285fdfd7d84fb965b3b338cd0a43eebefc478f1c800038997d0edbcd2e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a706f84f55da252784b0a8087a50c0faf5c0b287cdaeb21d9c25c928f13a6899"
    sha256 cellar: :any_skip_relocation, ventura:       "bdd6912c56f2b280ee335041d50b94b259a603e2617dfcf4cf85537afb492c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc53c371f041c1e103873de900cf673651c5957439c95db5529c39507b0e66d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end
