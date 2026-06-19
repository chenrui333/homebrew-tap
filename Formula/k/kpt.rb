class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.65.tar.gz"
  sha256 "01453b889440c113a8e1b823abc696dfdc5f415b160b05b9b218416c46072c96"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8be94ef4d3e9e10387702eba55d976e9ed3e612884685cd109f1872b03d86a06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8a4244fa4d1544b80d8c7974a5f1ac5f8be337e6ed1c96eb0cb22860f1f0795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd4c5bcd9db9fce6026874625cc1a2b532c6c116e8d1bbd1465bc08f65bfa6cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa0d3c055954385522ec9b1661b7060fe9447e85f677afbbad20469aa020fa3"
    sha256 cellar: :any,                 x86_64_linux:  "8d0464f9ca8988c9569c526f354b5f758f68f9d1c4fd147439f887dfc1d66892"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kptdev/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
