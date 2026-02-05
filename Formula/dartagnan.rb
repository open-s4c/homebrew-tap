class Dartagnan < Formula
  desc "Tool to check correctness properties under weak memory models"
  homepage "https://github.com/hernanponcedeleon/Dat3M"
  url "https://github.com/hernanponcedeleon/Dat3M/archive/refs/tags/4.3.1.tar.gz"
  sha256 "724a3d786a1e92901e324dc830acb77982500422728c3cb01dd69eec867bf83e"
  license "MIT"

  depends_on "openjdk@17"
  depends_on "maven" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix

    # Disable git-commit-id-plugin (tarball build has no .git)
    %w[dartagnan svcomp].each do |submodule|
      inreplace "#{submodule}/pom.xml" do |s|
        s.gsub!(/<execution>\s*<id>populate-git-commit-information<\/id>.*?<\/execution>/m, "")
      end
    end

    system "mvn", "clean", "install", "-DskipTests"

    # Install runtime artifacts in libexec (Homebrew standard)
    libexec.install "dartagnan/target/dartagnan.jar"
    (libexec/"libs").install Dir["dartagnan/target/libs/*.jar"]
    (libexec/"libs").install Dir["dartagnan/target/libs/*.dylib"]

    # Install upstream script
    bin.install "scripts/dartagnan" => "dartagnan.original"

    # Wrapper that sets the expected environment
    (bin/"dartagnan").write <<~EOS
      #!/bin/bash
      export DAT3M_HOME="#{libexec}"
      export DAT3M_JAVA="#{Formula["openjdk@17"].opt_prefix}/bin/java"
      exec "#{bin}/dartagnan.original" "$@"
    EOS
  end
end
