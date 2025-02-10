class Togomak < Formula
  desc "Declarative pipeline orchestrator"
  homepage "https://togomak.srev.in/"
  url "https://github.com/srevinsaju/togomak/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "a5d6f41cc98f8901c48158b2b8145f66e3b6aacc1f559527f2ee80be611df5a6"
  license "MPL-2.0"
  head "https://github.com/srevinsaju/togomak.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb7fde8d9089d423b6a3272599008554a15a2c87301b58f605bc1cc884d1a00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "877150628d064064de0776153ec788d6c18edf4b7902f1c3ae4d5a788f66ff81"
    sha256 cellar: :any_skip_relocation, ventura:       "930c554a4c13ec0b44d7823b7eb587b62d58e895947a82efff1bafc14fa8d554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb558a40993ae07392ae402cd3abcee22be3140693c8d7c4362e4789eb675ec5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/togomak"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/togomak --version")

    (testpath/"togomak.hcl").write <<~HCL
      togomak {
        version = 2
      }

      stage "fmt" {
        script = "go fmt github.com/srevinsaju/togomak/v1/..."
      }

      stage "vet" {
        script = "go vet github.com/srevinsaju/togomak/v1/..."
      }

      stage "build" {
        depends_on = [stage.fmt, stage.vet]
        script     = "go build -v -o ./cmd/togomak/togomak github.com/srevinsaju/togomak/v1/cmd/togomak"
      }

      stage "install" {
        depends_on = [stage.build]
        script     = "go install github.com/srevinsaju/togomak/v1/cmd/togomak"
      }

      stage "docs_serve" {
        daemon {
          enabled = true
        }
        if     = false
        script = "cd docs && mdbook serve"
      }
    HCL

    assert_match <<~EOS, shell_output("#{bin}/togomak list").gsub(/\e\[(\d+)m/, "")
      fmt
      vet
      build
      install
      docs_serve
    EOS
  end
end
