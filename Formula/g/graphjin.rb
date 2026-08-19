class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.28.tar.gz"
  sha256 "cfd17be5861697257680511aaf7aaf45fc5a957829dac46f3bce2f1521c88e7f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24090ecdc02b87cc767b999ec63dc449b83177fcfe38e8efa9576b2669f90f98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb824510aaad57f8a7bdc4c0117da769aec6d35ad1b8946d7c7c77924c331ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773a5023945f1b30f9e5caea498b6b2566baca4060c5e1e00a74dcda55280aa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e100bf52a1552c68c6c9676eed17631a2e4422fe930662c0309d166e6f071339"
    sha256 cellar: :any,                 x86_64_linux:  "994d7fdde300bdd998495395ba2752ffcb8df426c92d2946fddb2977107eb431"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
