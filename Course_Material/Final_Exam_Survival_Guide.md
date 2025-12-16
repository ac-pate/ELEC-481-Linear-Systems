# ELEC 481 Final Exam Survival Guide
**48-Hour Crash Course - Modern Control Theory**

---

## 🎯 CRITICAL EXAM TOPICS (Chapters 14-15 Heavy)

### **1. STATE FEEDBACK CONTROL (Lecture 14.1)**
**Problem Type:** "Design a controller u = -Kx to place closed-loop poles at..."

**Solution Template:**
1. **Check Controllability:** 
   ```
   Cx = [B  AB  A²B  ...  Aⁿ⁻¹B]
   If rank(Cx) = n → controllable → proceed
   ```

2. **Ackermann's Formula (if controllable):**
   ```
   K = [0 0 ... 0 1] · Cx⁻¹ · φc(A)
   
   Where φc(s) = desired characteristic polynomial
   φc(A) = αₙAⁿ + αₙ₋₁Aⁿ⁻¹ + ... + α₁A + α₀I
   ```

3. **Verify Closed-Loop:**
   ```
   Af = A - BK
   det(sI - Af) should equal φc(s)
   ```

**Key Example:** Lecture 14, Example 1
- Given: A = [0 1; 0 0], B = [0; 1]
- Desired poles: -1, -3
- Solution: K = [2 4]

**MATLAB/Python Verification:**
```matlab
A = [0 1; 0 0]; B = [0; 1];
desired_poles = [-1, -3];
K = place(A, B, desired_poles);
```

---

### **2. FULL-ORDER OBSERVER DESIGN (Lecture 14.2)**
**Problem Type:** "Design an observer to estimate states with poles at..."

**Solution Template:**
1. **Check Observability:**
   ```
   Ox = [C; CA; CA²; ...; CAⁿ⁻¹]
   If rank(Ox) = n → observable → proceed
   ```

2. **Observer Equation:**
   ```
   x̂̇ = (A - GC)x̂ + Bu + Gy
   ```

3. **Ackermann's Formula for G:**
   ```
   G = φe(A) · Ox⁻¹ · [0; 0; ...; 0; 1]
   
   Where φe(s) = desired observer characteristic polynomial
   Note: Observer poles should be 2-4× faster than controller poles
   ```

4. **Combined System:**
   ```
   u = -Kx̂  (use estimated states)
   Separation Principle: 
   Closed-loop poles = controller poles + observer poles
   ```

**Key Example:** Lecture 14, Example 3-4
- Controller poles: -4 ± j4
- Observer poles: -10, -10 (critically damped, faster)

---

### **3. REDUCED-ORDER OBSERVER (Lecture 14.3)**
**Problem Type:** "If some states are directly measured, estimate only unmeasured states"

**Why Use It:** If y = x₁ (you can measure x₁), only estimate x₂, x₃, etc.

**Solution Template:**
1. **Partition System:**
   ```
   [ẋ₁]   [A₁₁  A₁₂] [x₁]   [B₁]
   [ẋ₂] = [A₂₁  A₂₂] [x₂] + [B₂]u
   
   y = x₁  (measured directly)
   ```

2. **Design (n-q) order observer for x₂:**
   ```
   Estimator dimension = n - q
   where q = number of measured outputs
   ```

3. **Ackermann's Formula applies to reduced subsystem**

**Key Example:** Lecture 14, Example 7-8

---

### **4. TRACKING DESIGN (Lecture 15.1)**
**Problem Type:** "Design state feedback for zero steady-state error to step input"

**Solution Template:**
1. **Augment Control Law:**
   ```
   u = -Kx + Kr·r
   
   Where r = reference input
   ```

2. **Design Kr for Zero Steady-State Error:**
   ```
   At steady-state: ẋ = 0
   0 = (A - BK)x∞ + BKr·r
   y∞ = Cx∞ = r  (want output to track reference)
   
   Solve: Kr = 1 / [C(BK - A)⁻¹B]
   ```

3. **Alternative (simpler):**
   ```
   If system is Type 1: Kr = 1/DC_gain
   ```

**Key Example:** Lecture 15, Example 1
- Kr = 32 for DC motor system

---

### **5. POLE-ZERO ASSIGNMENT (Lecture 15.2-15.3)**
**Problem Type:** "Design controller with specific closed-loop T.F. including zeros"

**Key Insight:** State feedback adds **zeros** without adding poles!

**Solution Template:**
1. **Desired Closed-Loop T.F.:**
   ```
   Y(s)/R(s) = A(Ks³ + k₂s² + k₁s + k₀) / (sⁿ + αₙ₋₁sⁿ⁻¹ + ... + α₀)
   
   Poles: Set by state feedback K
   Zeros: Set by choosing k₀, k₁, k₂, etc.
   ```

2. **Design Steps:**
   - Use Controllable Canonical Form (CCF)
   - Match coefficients of desired vs. actual
   - Solve for K and gains

**Key Example:** Lecture 15, Examples 1-4 (DC motor, Root Locus improvements)

---

## 📝 PROBLEM-SOLVING STRATEGY (Your Exam Workflow)

### **Step 1: Identify Problem Type (30 seconds)**
- "Design controller" → State Feedback (14.1)
- "Estimate states" + "faster than plant" → Observer (14.2)
- "Some states measured" → Reduced Observer (14.3)
- "Zero steady-state error" → Tracking (15.1)
- "Closed-loop T.F. with zeros" → Pole-Zero Assignment (15.2)

### **Step 2: Check Conditions (1 minute)**
- Controllability: rank(Cx) = n?
- Observability: rank(Ox) = n?
- If not satisfied → STOP, state "system not controllable/observable"

### **Step 3: Apply Formula (5-10 minutes)**
- Write Ackermann's formula
- Compute matrices step-by-step
- Show intermediate results (partial credit!)

### **Step 4: Verify (2 minutes)**
- Check det(sI - Af) matches desired polynomial
- Verify steady-state error = 0 (if applicable)

---

## 🔑 COMMON EXAM TRICKS & PITFALLS

### **Trap 1: Forgetting to Check Controllability/Observability**
- **Always** compute Cx or Ox first
- If rank-deficient, design won't work!

### **Trap 2: Observer Poles vs. Controller Poles**
- Observer poles should be **2-4× faster** (more negative)
- Example: Controller at -2 → Observer at -8

### **Trap 3: Ackermann's Formula Order**
- For K (controller): `[0 0 ... 1] · Cx⁻¹ · φc(A)`
- For G (observer): `φe(A) · Ox⁻¹ · [0; ...; 1]`
- **Don't mix them up!**

### **Trap 4: Separation Principle**
- Closed-loop characteristic polynomial:
  ```
  det(sI - Af) · det(sI - Ae) = φc(s) · φe(s)
  ```
- Controller + Observer poles are **independent**

### **Trap 5: Kr Calculation**
- If problem says "zero steady-state error":
  ```
  Kr = -1 / [C(A - BK)⁻¹B]
  ```
- Check sign carefully!

---

## 📚 MUST-SOLVE EXAMPLES (Practice in Order)

### **Priority 1 (CRITICAL - Solve First):**
1. Lecture 14, Example 1: Basic state feedback (2×2 system)
2. Lecture 14, Example 3: Full-order observer design
3. Lecture 14, Example 4: Combined controller-observer
4. Lecture 15, Example 1: Tracking with Kr
5. Lecture 15, Example 2: DC motor pole placement

### **Priority 2 (High Probability):**
6. Lecture 14, Example 6: Closed-loop characteristic polynomial
7. Lecture 14, Example 7-8: Reduced-order observer
8. Lecture 15, Example 3: Root locus with state feedback

### **Priority 3 (If Time Permits):**
9. Lecture 13, Example 3-6: Jordan form (for complex systems)
10. Lecture 12, Example 4: CCF/OCF transformations

---

## 🧮 FORMULA SHEET (Memorize These)

### **Controllability Matrix:**
```
Cx = [B  AB  A²B  ...  Aⁿ⁻¹B]    (n×n)
```

### **Observability Matrix:**
```
Ox = [C; CA; CA²; ...; CAⁿ⁻¹]    (n×n)
```

### **Ackermann's Formula (Controller):**
```
K = [0 0 ... 0 1] · Cx⁻¹ · φc(A)
```

### **Ackermann's Formula (Observer):**
```
G = φe(A) · Ox⁻¹ · [0; 0; ...; 0; 1]
```

### **Cayley-Hamilton:**
```
φ(A) = αₙAⁿ + αₙ₋₁Aⁿ⁻¹ + ... + α₁A + α₀I = 0
```

### **State Transition Matrix:**
```
Φ(t) = e^(At) = I + At + (At)²/2! + (At)³/3! + ...
```

### **Solution of State Equation:**
```
x(t) = Φ(t-t₀)x(t₀) + ∫[t₀ to t] Φ(t-τ)Bu(τ)dτ
```

---

## ⏱️ EXAM TIME MANAGEMENT (3-Hour Exam)

### **Question Type Breakdown (Estimate):**
- **Q1-2:** Controllability/Observability checks (15 min each)
- **Q3-4:** State feedback design (25 min each)
- **Q5-6:** Observer design (30 min each)
- **Q7:** Tracking/pole-zero assignment (40 min)
- **Buffer:** 20 min for review

### **Time-Saving Tips:**
1. **Read all questions first** (5 min) - solve easiest ones first
2. **Show your work** - even wrong final answer gets partial credit
3. **Skip algebra-heavy parts** - write "using MATLAB/calculator" and jump to result
4. **Check units/dimensions** - catch silly errors early

---

## 🚨 PANIC MODE (If Stuck on Exam)

### **If you don't remember Ackermann's formula:**
1. Transform to CCF (you can always do this)
2. Read off coefficients directly
3. Write: "Using Controllable Canonical Form..."

### **If you can't compute matrix inverse:**
1. Write: "Using MATLAB: inv(...)"
2. Set up the equation correctly
3. Move to next part

### **If running out of time:**
1. Write the **setup** (show you know the approach)
2. Skip algebra → write final answer form
3. Move to next question

---

## 📖 STUDY SEQUENCE (Next 48 Hours)

### **Hour 0-4: Concepts** (Read this guide + Lectures 14-15)
- Understand what each method does (don't memorize yet)
- Watch YouTube: "State Feedback Control" by Brian Douglas

### **Hour 4-8: Formula Drilling**
- Write formulas 10× each on paper
- Create flashcards for Ackermann's formulas

### **Hour 8-16: Solve Priority 1 Examples**
- Do Example 1 (Lecture 14) - check answer
- Do Example 3 (Lecture 14) - check answer
- Repeat for all Priority 1 problems

### **Hour 16-24: Solve Priority 2 Examples**
- Focus on speed (aim for 20 min per problem)

### **Hour 24-32: Mock Exam**
- Solve old midterm problems under timed conditions
- Identify weak areas

### **Hour 32-40: Fix Weak Areas**
- Re-solve problems you got wrong
- Create "mistake log"

### **Hour 40-46: Final Review**
- Skim this guide
- Recite formulas out loud
- Sleep 6 hours before exam!

### **Hour 46-48: Pre-Exam Prep**
- Light review (don't cram new material)
- Bring formula sheet (if allowed)
- Get to exam 15 min early

---

## 💪 MINDSET RESET

**You said:** "I feel stupid... I failed both midterms..."

**Reality Check:**
- This material is **objectively hard** (graduate-level control theory)
- You have **48 hours** - that's enough for focused preparation
- You don't need 100% - you need **strategic mastery** of high-probability topics
- **Partial credit is your friend** - show work even if unsure

**Exam Day Mantra:**
> "I know controllability/observability checks. I know Ackermann's formula. I can design state feedback and observers. I will show my work and earn partial credit."

---

## 🎯 FINAL CHECKLIST (Print This for Exam)

- [ ] Can I compute Cx and check rank?
- [ ] Can I compute Ox and check rank?
- [ ] Do I know Ackermann's formula for K?
- [ ] Do I know Ackermann's formula for G?
- [ ] Can I write closed-loop system Af = A - BK?
- [ ] Do I know separation principle?
- [ ] Can I compute Kr for zero steady-state error?
- [ ] Have I solved at least 3 full examples end-to-end?

---

**YOU GOT THIS!** 🚀

Focus on Chapters 14-15. Master state feedback + observers. Show your work. Breathe.
