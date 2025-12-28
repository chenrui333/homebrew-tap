class Cozypkg < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozypkg"
  url "https://github.com/cozystack/cozypkg/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "167f184beceb030a1d15dd941bc7d2f90a89a97e9268eba98dfe94a2ca586e7f"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozypkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ed87835a8307e7dce7464ddb3a2fd8ff071855f664565cefed10b09ba706443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a3d57b394851210ba73db9feedbe82ff7f0459605e820a62bc4e910fc952c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ecda91e704c4745f3d777625794ed4cfa8f974b9a3afc4bc8afe718712dbc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b65edce408d864ffe76a1b41683701eb3e653cb147739199a8f02b4cdf4597f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa997a1eb8e862a0ec7f0b522a0e8d2b12790cf0a067118754cab93ac4f236c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"cozypkg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
