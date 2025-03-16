class Shuttle < Formula
  desc "CLI for handling shared build and deploy tools between many projects"
  homepage "https://github.com/lunarway/shuttle"
  url "https://github.com/lunarway/shuttle/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "4a8b93f01e9e21e543c393f59214145850895c89c2c6924a7faac6f8f12292cb"
  license "Apache-2.0"
  head "https://github.com/lunarway/shuttle.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "804cc3c23e7e69341ed6745afd91a5880558d328e9553f21edab49e3bbee34be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c3360fa06c9eee68e98723166c0aac541ef4843f28096905f2c140f03d28016"
    sha256 cellar: :any_skip_relocation, ventura:       "e13158cc693601d37ba516c04fd4923d6abcc9d2aa0b3a99a98f9976aa865fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5ea6e74fd6ada0167e070f9ee5af2510d2fbedac2852a4332540ac16a3aef0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lunarway/shuttle/cmd.version=#{version}
      -X github.com/lunarway/shuttle/cmd.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"shuttle", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle version")

    (testpath/"shuttle.yaml").write <<~YAML
      plan: 'https://github.com/lunarway/shuttle-example-go-plan.git'
      vars:
        docker:
          baseImage: golang
          baseTag: stretch
          destImage: repo-project
          destTag: latest
    YAML

    assert_match "Plan:", shell_output("#{bin}/shuttle config")

    output = shell_output("#{bin}/shuttle telemetry upload 2>&1", 1)
    assert_match "SHUTTLE_REMOTE_TRACING_URL or upload-url is not set", output
  end
end
