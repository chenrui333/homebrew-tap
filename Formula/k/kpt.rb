class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.58.tar.gz"
  sha256 "402557778e1fd32674facd97ae68c7d1e96cbc161d5a676adc71d4709ca7836a"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcc778892b2b200ea2f32451f63661e861e2b9673762e96a171d90479c683ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0381c4d056c7366ca47335695bf976300384559bff60f08050836d8c8773ab4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb50f64d5d77ab2961e014c071f0d0254d5bb9b7502bad54a9da6409537de17f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kptdev/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
