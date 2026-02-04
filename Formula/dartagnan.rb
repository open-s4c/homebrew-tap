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
    
    # Disable git-commit-id-plugin in all submodules
    %w[dartagnan svcomp].each do |submodule|
      inreplace "#{submodule}/pom.xml" do |s|
        s.gsub! /<execution>\s*<id>populate-git-commit-information<\/id>.*?<\/execution>/m, ""
      end
    end
    
    system "mvn", "clean", "install", "-DskipTests"
    
    # Install JAR and all dependencies
    libexec.install "dartagnan/target/dartagnan.jar"
    libexec.install Dir["dartagnan/target/libs/*.jar"]
    libexec.install Dir["dartagnan/target/libs/*.dylib"]
    
    # Create wrapper script
    (bin/"dartagnan").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Formula["openjdk@17"].opt_prefix}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/dartagnan.jar:#{libexec}/*" com.dat3m.dartagnan.Dartagnan "$@"
    EOS
  end

  test do
    system "#{bin}/dartagnan", "--version"
  end
end