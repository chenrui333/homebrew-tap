class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "2600226b12cbe8a6e9bf5b8f8de2a2c34a04886fef2283a1465ee1ac0f6f35cb"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bb06fc2589701b5d6d81f1b901cfde6650d5d1ac6dd3edbdafbfcbede20f395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a4a655b315cdbaf9993ed17fca25305c11dd7e5899b7ed37c309039912d7bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b457e6931267eb805f1425ab3849ad646d983a303707cea14ab11df65782c6d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1d5ce0cbbcb617120a90b04164d3294b34e962872389806aa81362b2918ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e986720e5d01c29df36a1c7501118436898fcdb804ebd3be60920523f2e44b72"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
