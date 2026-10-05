class Horusec < Formula
  desc "Improve identification of vulnerabilities in your project with just one command"
  homepage "https://github.com/ZupIT/horusec"
  url "https://github.com/ZupIT/horusec/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "3824728b7b29656416aaf23ff8cbda62fe9921d2fb982c19f8cda4f0df933592"
  license "Apache-2.0"
  head "https://github.com/ZupIT/horusec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc88f50db6a33b2ddda1316356fbac0001e3500671a69b2d3469f66cafc716b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc88f50db6a33b2ddda1316356fbac0001e3500671a69b2d3469f66cafc716b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ef966c846b7e6d1132b08bbd19b30a8b2334a64acfdbf79f2bb00ca02d9f5e"
    sha256 cellar: :any,                 x86_64_linux:  "9334aef8bf1342befe88d307b43976f9972ea9a6f0cdc4e4be27b49a5cc92a89"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/ZupIT/horusec/cmd/app/version.Version=#{version}
      -X github.com/ZupIT/horusec/cmd/app/version.Commit=#{tap.user}
      -X github.com/ZupIT/horusec/cmd/app/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/app"

    generate_completions_from_executable(bin/"horusec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/horusec version 2>&1")
    system bin/"horusec", "generate"
    assert_match "\"horusecCliCertInsecureSkipVerify\": false", (testpath/"horusec-config.json").read
  end
end
