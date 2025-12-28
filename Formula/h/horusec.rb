class Horusec < Formula
  desc "Improve identification of vulnerabilities in your project with just one command"
  homepage "https://github.com/ZupIT/horusec"
  url "https://github.com/ZupIT/horusec/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "3824728b7b29656416aaf23ff8cbda62fe9921d2fb982c19f8cda4f0df933592"
  license "Apache-2.0"
  head "https://github.com/ZupIT/horusec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33c8faa9cbe98e3695d692b8b0097c919f241caac373bbd446f70fb7ef199691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33c8faa9cbe98e3695d692b8b0097c919f241caac373bbd446f70fb7ef199691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33c8faa9cbe98e3695d692b8b0097c919f241caac373bbd446f70fb7ef199691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6657e4285aa8926d741c1ee1476849c3fe99ae2771d17a80bf49300809bc230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095146b8bf4a70bad26f7ebe2e2df735965aebd34f349a359b25c1be4a76de28"
  end

  depends_on "go" => :build

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
