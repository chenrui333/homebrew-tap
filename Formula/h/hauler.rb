class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "29420fc2eaf99c3a751a3a405a9a28ae4a22f4edde042d83d5d2d8634e3c940f"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a128ded4ac006c9195d2a786e3403ce21095d6dd13b3113bcf11c1d79ea5cdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71f88bcafabcc15686748bd431cd8f4827d1df63aa7714007101e911b98b0f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c85bd14870643d7071f1bff41506701aca914a6f75aa3964d5410f452f7b915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c6f466109fea253d976a7c8986df07ef88b08bc34e1cd66ab6f7758269bade0"
    sha256 cellar: :any,                 x86_64_linux:  "0f1f2774b6063b185f41398c4b49378791677c8df76831662c2417cc960e6d11"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/v2/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/v2/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/v2/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/v2/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
